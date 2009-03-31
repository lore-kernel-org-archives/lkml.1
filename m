Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbZCaPDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbZCaPDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760046AbZCaPCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:02:49 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:44765 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbZCaPCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:02:48 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Mark Williamson <mark.williamson@cl.cam.ac.uk>
To: Xavier Bestel <xavier.bestel@free.fr>
Subject: Re: Replacing VFAT as filesystem on removeable media
Date: Tue, 31 Mar 2009 16:02:39 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, info@fsf.org, office@fsfeurope.org,
       info@linuxfoundation.org
References: <200903311015.29222.Martin@Lichtvoll.de> <200903311357.44075.mark.williamson@cl.cam.ac.uk> <1238507227.27596.559.camel@skunk>
In-Reply-To: <1238507227.27596.559.camel@skunk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903311602.41272.mark.williamson@cl.cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xav,

On Tuesday 31 March 2009 14:47:07 Xavier Bestel wrote:
> On Tue, 2009-03-31 at 13:57 +0100, Mark Williamson wrote:
> > Another approach which occurs to me would be to come up with a
> > "filesystem over USB" protocol so that the actual on-disk format is no
> > longer relevant.
>
> Look for MTP. It's what you want, made by Microsoft, and enables all
> sorts of DRM niceties.

Ah, thanks for that.  It looks fairly close to what I had in mind, although I 
think there are some differences (it transfers whole files at a time and 
incorporates device control stuff - neither of which is really necessary in the 
scheme I imagined).

According to Wikipedia  it is now an official USB device class, which sounds 
attractive.  I've not heard of Linux providing an MTP responder ("server"), 
which I find mildly surprising as it sounds like it would be useful, 
particularly given the range of advanced filesystems Linux devices might like 
to leverage under the hood.  It seems odd if an embedded Linux company hasn't 
already coded this up for a device ... ?

I can see how a file-based protocol would be "useful" in enforcing DRM-like 
protections in a device implementation but I don't think that such protocols 
fundamentally enables any nastiness that couldn't be enforced in other ways by 
a motivated pro-DRM device manufacturer.  Sounds like MTP is designed to 
facilitate DRM if the communications endpoints want it; not something I'm keen 
on but also not something that rules it out as a useful standard.

A file-based transfer protocol seems like it would be useful to have for 
"sufficiently intelligent" devices, whether it's MTP or something else.

Cheers,
Mark
