Return-Path: <linux-kernel-owner+w=401wt.eu-S1760355AbYC0Qab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbYC0Qab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbYC0QaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:30:24 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48104 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbYC0QaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:30:23 -0400
Subject: Re: [kvm-devel] kvm causing memory corruption?  ~2.6.25-rc6
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
In-Reply-To: <47EBB63E.2060306@qumranet.com>
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	 <47EA1C63.8010202@qumranet.com>
	 <1206550329.7883.5.camel@nimitz.home.sr71.net>
	 <47EA80AC.4070204@qumranet.com>
	 <1206551794.7883.7.camel@nimitz.home.sr71.net>
	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>
	 <1206629709.7883.30.camel@nimitz.home.sr71.net>
	 <47EBB63E.2060306@qumranet.com>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 09:30:17 -0700
Message-Id: <1206635417.7883.76.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 16:59 +0200, Avi Kivity wrote:
> Dave Hansen wrote:
> > On Thu, 2008-03-27 at 12:10 +0200, Avi Kivity wrote:
> >> btw, is this with >= 4GB RAM on the host?
> >>     
> > Well, are you asking whether I have PAE on or not? :)
> 
> No, I'm asking whether there is a possibility of address truncation :)
> 
> PAE by itself doesn't affect kvm much, as it always runs the guest in 
> pae mode.
> 
> Can you try running with mem=2000M or something?

Oh, sure.  I'll give that a shot.

-- Dave

