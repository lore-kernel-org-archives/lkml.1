Return-Path: <linux-kernel-owner+w=401wt.eu-S1751068AbXCJSX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbXCJSX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 13:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbXCJSX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 13:23:59 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:46343 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbXCJSX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 13:23:58 -0500
Date: Sat, 10 Mar 2007 19:23:41 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
In-Reply-To: <20070310175058.GA19878@cvg>
Message-ID: <Pine.LNX.4.61.0703101906070.8799@yvahk01.tjqt.qr>
References: <20070310160542.21cdb968@localhost> <20070310160614.GB10230@cvg>
 <Pine.LNX.4.61.0703101724160.8799@yvahk01.tjqt.qr> <20070310194617.2aef1006@localhost>
 <Pine.LNX.4.61.0703101747530.8799@yvahk01.tjqt.qr> <20070310175058.GA19878@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 10 2007 20:50, Cyrill Gorcunov wrote:
>
>lets see to the following scenario:
>
>	1) I've taken a pure Linux kernel (no .config at all)
>	2) I started menuconfig, made a few changes and saved the file
>	to .config1 as alternate
>	3) Then I made some additional changes
>	4) Then I'm getting out of menuconfig and of course "Save
>	configuration..?" question is raising. Ok, I'm selecting
>	"Yes" and as result new configuration will be written to the .config
>	file. All works as it should be...
>	
>...but as you mentoined in your message "perhaps all Office Suites do
>the same" - no, Office do not the same.


	1) I start a new document
	2) add some text, "save as" it to config1.txt
	3) make more text
	4) choose File,Exit - prompts me to save

(perhaps not to .config, but instead config1.txt, but at least, it prompts
me, and gives me the choice to go back into menuconfig and save it under a
different name). So what I just wanted to make clear is that you don't
lose any changes without explicitly saying Don't Save.

>The only question I have (and it could resolve all our problems) - what an
>alternate config file is:
>
>	- just a snapshot of a config tree at moment of its writting
>	- _working_ file to which configurator should write parameters
>
>your comments?

Whether the 'working config file path' should change when you do
'Save as Alternate' or not, is a menuconfig axiom. Ask Sam Ravnborg
if you want it changed :-)

[ I see where you are going. I am not biased to either because I usually
  only use it to save to .config. ]



Jan
-- 
