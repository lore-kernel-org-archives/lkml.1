Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZEOSkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZEOSkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZEOSkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:40:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:60422 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbZEOSkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:40:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Qx8XAj39W6uPsLQyt75+GZ23Lqc9xoR53hdPzItYt7Ce5PFbiIIrkCzAlObz7xrK1V
         HReGlqFZmFBH9f3uvBDupQG6Q45k2jUaEQkxksGZuVM06/tG9kKHMXbh7cOLxWfLnqvV
         MrDmnpipBV4cRZuoA0Yjx+rNdEGCcHM4o/AYQ=
Message-ID: <4A0DB70F.5000209@gmail.com>
Date: Fri, 15 May 2009 20:40:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b5pre) Gecko/20090511 SUSE/3.0b2-9.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
       Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com> <20090515182131.GA6439@fancy-poultry.org>
In-Reply-To: <20090515182131.GA6439@fancy-poultry.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2009 08:21 PM, Heinz Diehl wrote:
> This patchset crashes my WLAN. Reverting it does fix this:

Could you try this fix
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff_plain;h=b3f25c62aa41e0c372536c0f3975b39f21217b57;hp=30e2341dd2c82780eddd785eb54695115c6aea8d
?
