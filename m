Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbZE2Ojs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbZE2Ojs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 10:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbZE2Ojk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 10:39:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:23692 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759564AbZE2Ojj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 10:39:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Bz4UGic8oszx/SDuLxOOBdxwuqyKtLMP6/K12dqWLZbKnR4bfVEsokLMdVKvnMxUcN
         GJf0alZz/xTHBbn8tJ00uPW0jwQaazLUCOIpSeBj2G0cTniUDpQCI8cb7hFQTyLXj+l3
         0VDAL5TOYoVKED9WL5y2F7LbyLpg6e4HSY4wE=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Date: Fri, 29 May 2009 07:39:33 -0700
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6; KDE/4.2.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, mingo@elte.hu
References: <20090511072135.GA4682@sucs.org> <20090528164942.GC18589@dtor-d630.eng.vmware.com> <20090529093126.GA30979@sucs.org>
In-Reply-To: <20090529093126.GA30979@sucs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905290739.34414.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 May 2009 02:31:26 Sitsofe Wheeler wrote:
> On Thu, May 28, 2009 at 09:49:43AM -0700, Dmitry Torokhov wrote:
> > On Thu, May 28, 2009 at 05:42:31PM +0100, Sitsofe Wheeler wrote:
> > > On a normal boot there will be exactly 115 interrupts if the trackpad
> > > hasn't been touched but everything is OK just after booting. If there
> > > are less interrupts you know something has gone wrong...
> >
> > OK, I guess I will be pushin this to Linus then... Thank you for
> > testing.
>
> Should I be trying to get you some extra logs (I saw and replied to
> Ingo's mail)?  If no one else has this problem is this just a symptom of
> a bigger problem (i.e. broken scheduling or unstated assumptions)?

Not to me but I'd guess to Ingo/scheduler guys... my patch is just a
work-around; I think it would be great to figure out why the thread
is not woken up until so much later. Such delays could have an adverse
effects not only on input devices but elsewhere as well.  

-- 
Dmitry
