Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYBXAst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYBXAst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 19:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYBXAsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 19:48:42 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:37633 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYBXAsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 19:48:42 -0500
Message-ID: <47C0BEE7.4040409@student.ltu.se>
Date: Sun, 24 Feb 2008 01:48:39 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Tabs, spaces, indent and 80 character lines
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good evening

In the thread "Merging of completely unreviewed drivers" I got reminded 
of the "use tabs not spaces"-mentality.
My question is: why?

The tab-character serves us well as a indent-indicator, but for some 
reason there has been focus on its relation to spaces. On the question 
"How long should a line at maximum be?" it is relevant (the question is 
not [1]). So it is set to be as wide as 8 spaces, but when did it become 
a replacement for 8 spaces? Why hinder a developer who prefer 2, 4, 6 or 
any other != 8 width? By only using tabs as indents, and changing the 
CodeStyle to be something like "maximum 80 characters-wide lines, with a 
tab-setting of 8 spaces", that is possible + easier to write 
code-checkers [2].

Or are we really that concerned about the disk-space? ;)

2 cents away...
/Richard Knutsson

[1] As has been pointed out by many, it is the complexity that matters 
(code-checker). A short line can be overly complicated and still under 
80 lines and vice versa. Let the editors handle the long lines for the 
author (even I should be able to write a decent script who can decide 
where to chop-off the line).

[2] As it is now, it can look like the indentation is ex. ... 2, 2, 5, 
3, 3... because the second line is split up. (I think it should have 
been 2, 2, 2, 3, 3 (or even better: 2, 2, 3, 3 ))

