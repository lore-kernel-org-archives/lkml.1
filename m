Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYJCWMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYJCWMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 18:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYJCWMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 18:12:40 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:56697 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853AbYJCWMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 18:12:40 -0400
Subject: Re: kexec with vmware esx 3.0.2
From: Zachary Amsden <zach@vmware.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>, Alok Kataria <akataria@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>
In-Reply-To: <86802c440810031458s1ce79589s2448aa0869a74e21@mail.gmail.com>
References: <86802c440810031408i60e2036ax805bfd997092cd86@mail.gmail.com>
	 <1223068893.7330.117.camel@bodhitayantram.eng.vmware.com>
	 <86802c440810031440o59359f30ka72230b4b0ff73e@mail.gmail.com>
	 <1223070521.7330.122.camel@bodhitayantram.eng.vmware.com>
	 <86802c440810031458s1ce79589s2448aa0869a74e21@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 15:08:51 -0700
Message-Id: <1223071731.7330.127.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-03 at 14:58 -0700, Yinghai Lu wrote:
> On Fri, Oct 3, 2008 at 2:48 PM, Zachary Amsden <zach@vmware.com> wrote:
> > On Fri, 2008-10-03 at 14:40 -0700, Yinghai Lu wrote:
> >> On Fri, Oct 3, 2008 at 2:21 PM, Zachary Amsden <zach@vmware.com> wrote:
> >> > On Fri, 2008-10-03 at 14:08 -0700, Yinghai Lu wrote:
> >> >> anyone tried to use linux kernel to kexec vmware esx?
> >> >
> >> > That would not be a recommended practice.  It might work.  It should not
> >> > be very useful.
> >> >
> >>
> >> esx 3.0.2 relys on correct mps table,
> >> could boot linux with update_mptable or alloc_mptable, and then load
> >> vmware with kexec.
> >
> > And end up running ESX on hardware where it is not supported and you
> > already have a buggy BIOS?
> BIOS is not buggy... vmware seems not to be smart enough to correct pic mode.
> because current linux kernel could works well with acpi=off

BIOS is missing correct MP table.  Thus buggy.  You should not be trying
to run ESX on buggy hardware.

Zach

