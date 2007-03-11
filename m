Return-Path: <linux-kernel-owner+w=401wt.eu-S1751330AbXCKHrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbXCKHrn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 03:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbXCKHrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 03:47:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:2681 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXCKHrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 03:47:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=L0GkFJYNVPCXrfhpMjK5GOFoLJ5vNeqktvpEGFAoHXTqQaDe20owXuvKSxOV917YL5I1ND00XdntNgnZiH0eZ/rtTQB5+h5R0v55tOYKGBXa2S3gWnb0HQ2lINWXm7Sgz5IfR5Y/42mWMI4JyQ2Grh5hShM0WuknrjmfLxetjdM=
Date: Sun, 11 Mar 2007 10:44:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
Message-ID: <20070311074416.GA10572@cvg>
References: <20070310160542.21cdb968@localhost> <20070310160614.GB10230@cvg> <Pine.LNX.4.61.0703101724160.8799@yvahk01.tjqt.qr> <20070310194617.2aef1006@localhost> <Pine.LNX.4.61.0703101747530.8799@yvahk01.tjqt.qr> <20070310175058.GA19878@cvg> <Pine.LNX.4.61.0703101906070.8799@yvahk01.tjqt.qr> <20070310212730.GA2577@uranus.ravnborg.org> <Pine.LNX.4.61.0703102234210.26332@yvahk01.tjqt.qr> <20070310224534.GA3150@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310224534.GA3150@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Sat, Mar 10, 2007 at 11:45:34PM +0100]
| On Sat, Mar 10, 2007 at 10:34:41PM +0100, Jan Engelhardt wrote:
| > 
| > On Mar 10 2007 22:27, Sam Ravnborg wrote:
| > >On Sat, Mar 10, 2007 at 07:23:41PM +0100, Jan Engelhardt wrote:
| > >> 
| > >> Whether the 'working config file path' should change when you do
| > >> 'Save as Alternate' or not, is a menuconfig axiom. Ask Sam Ravnborg
| > >> if you want it changed :-)
| > >
| > >Current behaviour is not logical but on the other hand I do not
| > >see a big need to make it so.
| > >It seems that people very seldom uses "save alternate" anyway.
| > >
| > >But patches are welcome.
| > 
| > ^_^ The patch has already been posted, has not it?
| No.
| Either we keep current behaviour or we change to the "normal"
| behaviour with a "Save as..." as know from all other programs.
| 
| 	Sam
| 

Hi Sam,

I think we should use "Save As..." idea. And thereby menuconfig,
qconfig, gconfig will be affected. Please give me time to make patches.
(I'm a little busy now so I hope to make them during a week :)

The patch I sent to Vladimir does not normalize behaviour of config
process but just makes an alternate file as a snapshot of current config
state. You may review it as a temporary solution only.

		Cyrill

