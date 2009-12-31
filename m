Return-Path: <linux-kernel-owner+w=401wt.eu-S1751522AbZLaMA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbZLaMA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 07:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZLaMA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 07:00:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57676 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZLaMA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 07:00:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=BGfRe7O55vDPVjftFG7UI/tgYNzdJwl3B1zPwOH44RdY/kD0JD7LquWQDWDI7gk3Vr
         lSY+TzYBXJN1Ll5Rv+XhtjN6HXoTzyzg5/Zlem1p7MCTfPlHzuDoFqH6HFAQocRIUfkl
         KfgAb6tGH/thjnvMVthJdQr8HlkAo8o5OJ1So=
Message-ID: <4B3C931A.70104@gmail.com>
Date: Thu, 31 Dec 2009 13:03:38 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: tty: &&/|| confusion in mxser_get_ISA_conf()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vi drivers/char/mxser.c +2460 and note:

if ((irq != regs[9]) || (irq != regs[10]))

Should this be an && ?

Roel

