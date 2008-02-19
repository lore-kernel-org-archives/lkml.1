Return-Path: <linux-kernel-owner+w=401wt.eu-S1763024AbYBSJuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763024AbYBSJuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYBSJu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:50:26 -0500
Received: from smtp01.isdsl.net ([196.26.208.190]:64735 "EHLO smtp01.isdsl.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760743AbYBSJuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:50:21 -0500
X-Greylist: delayed 1487 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2008 04:50:20 EST
X-netsentry.modernarch.co.za-MailScanner-Watermark: 1204017901.91211@l8h5vZ7oVgya2U/SBJjC8Q
Message-ID: <47BAA072.9050601@networksentry.co.za>
Date: Tue, 19 Feb 2008 11:25:06 +0200
From: Gregory Nietsky <gregory@networksentry.co.za>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org>
In-Reply-To: <20080219085033.GA1775@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-netsentry.modernarch.co.za-MailScanner-Information: Please contact Network Sentry  for more information (www.networksentry.co.za)
X-netsentry.modernarch.co.za-MailScanner: Found to be clean
X-netsentry.modernarch.co.za-MailScanner-From: gregory@networksentry.co.za
X-Scan-Signature: 8def3a10a9879563ddd78557522be15f{62}}
X-Trace: smtp01.isdsl.net 1JROir-000J9P-H9 614bd3979eccf9ce2c100451791ec772
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ive been hackin away at mISDN for a while and use it with recent kernels 
  2.6.2X and have a patch for 2.6.24 (move from semaphore to complition) 
the distro we built is heavily reliant on mISDN (voip) i dont use the 
isdn kernel drivers at all any longer.

im all for mISDN been mainlined into the kernel and the old stuff been 
removed there could be users still it is marked as depricated and the 
plan was with 2.6 to use mISDN from the start.


Greg

Sam Ravnborg wrote:
> On Mon, Feb 18, 2008 at 01:08:33PM +0100, Andi Kleen wrote:
>> Greg KH <greg@kroah.com> writes:
>>> If Jeff does that, I still can't drop those PCI functions from the PCI
>>> core, which I desperatly want to do as they do not play nice with modern
>>> systems (meaning hotplug...).
>>>
>>> So either way, I think his patches should go in.
>> Merging essentially untested patches does not seem like a good strategy.
>> And there is definitely still a large ISDN user base too.
> Only issue seems that this large ISDN user base is not very active
> in respect to Linux driver development.
> Or at least not judging from the missing responses to their
> mailing list and the limited traffic on said mailing list.
> 
> Reading the isdn4linux it is obvious that the way forward are the
> mISDN code base so maybe that explains why noone steps up and 
> test the patches of Jeff's.
> 
> If noone in the isdn community step up and take some responsibility
> for the current isdn drivers in Linux then we should just delete them.
> If anyone cares they can always be forwardported or even better we can 
> integrate the much more flexible mISDN solution.
> 
>> My personal guess is that there are far more ISDN users than (non cardbus)
>> PCI/PCI-e hotplug users.
> 
> My guess is that very very few uses ISDN in combination with a recent kernel.
> Hmm, wonder if it is more fun hacking isdn drivers than kbuild
> stuff and section mismatches ;-)
> 
> 	Sam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--

This message has been scanned for viruses and

dangerous content by Superset Technology, and 

is believed to be clean.

http://www.superset.co.za


