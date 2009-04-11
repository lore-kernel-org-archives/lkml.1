Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbZDKUbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbZDKUbb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 16:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbZDKUaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 16:30:14 -0400
Received: from mail.1dial.com ([64.136.164.73]:4726 "EHLO
	MAIL02.inside.adbasesystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759005AbZDKUaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 16:30:13 -0400
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Apr 2009 16:30:13 EDT
X-Modus-BlackList: 64.124.13.3=OK;MrUmunhum@popdial.com=OK
X-Modus-RBL: 64.124.13.3=0000232A
X-Modus-Trusted: 64.124.13.3=NO
X-Modus-Audit: FALSE;0;0;0
Message-ID: <49E0FB52.4030702@popdial.com>
Date: Sat, 11 Apr 2009 13:19:30 -0700
From: William Estrada <MrUmunhum@popdial.com>
Reply-To: MrUmunhum@popdial.com
Organization: Mt Umunhum Wireless
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: VT, unicode not working
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi group,

I am trying to get ubicode output to work on the VT consoles. I have done
a lot of reading and it looks like a keRnel problem?

This script run on an X window work right:

    echo -e \
    " \t\xE2\x96\x9B\xE2\x96\x80\xE2\x96\x9C\n" \
    " \t\xE2\x96\x8C" "\xE2\x96\x90\n" \
    " \t\xE2\x96\x99\xE2\x96\x84\xE2\x96\x9F\n"

It produces:

    test-box
    ▛▀▜
    ▌ ▐
    ▙▄▟

On a VT it shows something like this:

    vt-test
    ▖▀▗
    ▌ ▐
    ▘▄▝

Any ideas on how I can fix this?? I have other examples/sample programs.


-- 
William Estrada
MrUmunhum@popdial.com
Mt-Umunhum-Wireless.net ( http://64.124.13.3 )
Ymessenger: MrUmunhum


