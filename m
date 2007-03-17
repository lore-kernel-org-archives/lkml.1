Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbXCQOm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbXCQOm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 10:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXCQOm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 10:42:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:1035 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbXCQOmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 10:42:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=uaz2ZjQpJBAzda+U8S9lK9lc+8Z7RshPXBnWCQs/lBfMPNDg6aU4PqsZVF1W4UDvhIy7ZQ8E7DkXbt9r5JcUbZP3Mo+NF05CyWtE4uIRyXldX8/ed4U5lXWu5hmZSTmHnVUbyGyFazpHtxngdXMbJjU0CfvqEtijpAlBLPK8yoQ=
Date: Sat, 17 Mar 2007 17:38:44 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
Message-ID: <20070317143844.GA10920@cvg>
References: <Pine.LNX.4.61.0703101724160.8799@yvahk01.tjqt.qr> <20070310194617.2aef1006@localhost> <Pine.LNX.4.61.0703101747530.8799@yvahk01.tjqt.qr> <20070310175058.GA19878@cvg> <Pine.LNX.4.61.0703101906070.8799@yvahk01.tjqt.qr> <20070310212730.GA2577@uranus.ravnborg.org> <Pine.LNX.4.61.0703102234210.26332@yvahk01.tjqt.qr> <20070310224534.GA3150@uranus.ravnborg.org> <20070311100723.GA10359@cvg> <20070311195033.GA3302@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311195033.GA3302@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Sun, Mar 11, 2007 at 08:50:33PM +0100]
| On Sun, Mar 11, 2007 at 01:07:23PM +0300, Cyrill Gorcunov wrote:
| > [Sam Ravnborg - Sat, Mar 10, 2007 at 11:45:34PM +0100]
| > | On Sat, Mar 10, 2007 at 10:34:41PM +0100, Jan Engelhardt wrote:
| > | > 
| > | > On Mar 10 2007 22:27, Sam Ravnborg wrote:
| > | > >On Sat, Mar 10, 2007 at 07:23:41PM +0100, Jan Engelhardt wrote:
| > | > >> 
| > | > >> Whether the 'working config file path' should change when you do
| > | > >> 'Save as Alternate' or not, is a menuconfig axiom. Ask Sam Ravnborg
| > | > >> if you want it changed :-)
| > | > >
| > | > >Current behaviour is not logical but on the other hand I do not
| > | > >see a big need to make it so.
| > | > >It seems that people very seldom uses "save alternate" anyway.
| > | > >
| > | > >But patches are welcome.
| > | > 
| > | > ^_^ The patch has already been posted, has not it?
| > | No.
| > | Either we keep current behaviour or we change to the "normal"
| > | behaviour with a "Save as..." as know from all other programs.
| > | 
| > | 	Sam
| > | 
| > 
| > Hi Sam,
| > 
| > here is a patch for menuconfig that shows current configuration
| > file. So I think menuconfig does its work well but the only
| > thing we need is to show location of an _active_ configuration.
| > 
| > Any comments are welcome (and you may swear at me too :)
| I would rather avoid adding the extra lines. In the
| 'office-suite' fashion I have cooked up a patch that specify
| the filename as part of the windows title.
| 
| To make the conversion we should consider renaming from
| current "Load alternate" to "Open config file..."
| and likewise "Save alternate" to "Save config file as..."
| 
| Comments?
| 
| 	Sam

[... snip ...]

Hi Sam,

maybe my prev letter was lost, so let me repeat - I think your patch
is pretty good to be merged into kernel. Did you send any patch to
Andrew? Btw I think we may leave "Load Alternate..." and "Save
Alternate..." as is - the user always may know what the config he is
using on the main dialog title :)

		Cyrill

