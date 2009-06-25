Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbZFYOgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbZFYOgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZFYOgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:36:06 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:38449 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbZFYOgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:36:05 -0400
Date: Thu, 25 Jun 2009 10:34:05 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: next cleanup report:  "bad" references to CONFIG variables
Message-ID: <alpine.LFD.2.00.0906251028270.24694@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  here's the next cleanup report that's well underway -- "bad"
references to CONFIG variables that don't exist in any Kconfig file:

  http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables

(currently, only the arch/ and drivers/ directories have been updated
-- the rest should be done shortly.)

  in a nutshell, that's a list of references to variables of the form
CONFIG_*, where there is no such variable defined anywhere in a
Kconfig file.  some possible reasons for that:

  1) leftover historical cruft
  2) simple typo
  3) someone's added code without adding the Kconfig infrastructure
     for it (annoyingly, there appears to be quite a lot of that)
  4) someone likes to name their macros with a "CONFIG_" prefix just
     to pollute the Kconfig namespace (argh)

in any event, it's all there (some of it starting to look awfully
familiar as the years go by).  as always, ignore the false positives.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
