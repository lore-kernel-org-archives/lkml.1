Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbYJCVke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbYJCVke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 17:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYJCVk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 17:40:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:62419 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYJCVkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 17:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=IZxi+5VSGSROXoJ4ycqo3I3TjvXKOclT6Bz2aoG84qHs61yM4luHBXqnXazwXiiBYW
         TES49S/p/lNdVqORNWNTNug7vi1OlX7WnDEJfZoVIXnnF3vpkjjXYscFqVt7MJlRkaw2
         HRoiJFGz3pApOXzCeWrvuGVMYNQoSw6g8klTg=
Message-ID: <86802c440810031440o59359f30ka72230b4b0ff73e@mail.gmail.com>
Date: Fri, 3 Oct 2008 14:40:24 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Zachary Amsden" <zach@vmware.com>
Subject: Re: kexec with vmware esx 3.0.2
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Vivek Goyal" <vgoyal@redhat.com>, "Alok Kataria" <akataria@vmware.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>
In-Reply-To: <1223068893.7330.117.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440810031408i60e2036ax805bfd997092cd86@mail.gmail.com>
	 <1223068893.7330.117.camel@bodhitayantram.eng.vmware.com>
X-Google-Sender-Auth: e9ff97f40705dc9f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2008 at 2:21 PM, Zachary Amsden <zach@vmware.com> wrote:
> On Fri, 2008-10-03 at 14:08 -0700, Yinghai Lu wrote:
>> anyone tried to use linux kernel to kexec vmware esx?
>
> That would not be a recommended practice.  It might work.  It should not
> be very useful.
>

esx 3.0.2 relys on correct mps table,
could boot linux with update_mptable or alloc_mptable, and then load
vmware with kexec.

YH
