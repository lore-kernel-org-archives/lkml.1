Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYIMCSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYIMCSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 22:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbYIMCRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 22:17:51 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:33681 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbYIMCRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 22:17:50 -0400
Message-ID: <f488382f0809121917vaabfcre710c9e6d4f39a12@mail.gmail.com>
Date: Fri, 12 Sep 2008 19:17:49 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: frustrating ath9k issues in 2.6.27-rc6-00036-ga551b98 (Linus pristine tree)
In-Reply-To: <f488382f0809121837n69cf4bc5i3dfa04cbf671957b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809121837n69cf4bc5i3dfa04cbf671957b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just had another incident where it disassociated and refused to
reassociate. I got about 100 of these in my dmesg (fixed by unloading
and reloading ath9k):

[...]
[ 1279.031033] ath_set_channel: unable to reset channel 149 (5745Mhz)
flags 0x30142 hal status 4294967277
[ 1279.031203] ath9k_config: Unable to set channel
[ 1279.323427] ath_set_channel: unable to reset channel 153 (5765Mhz)
flags 0x50142 hal status 4294967277
[ 1279.323577] ath9k_config: Unable to set channel
[ 1279.624562] ath_set_channel: unable to reset channel 157 (5785Mhz)
flags 0x30142 hal status 4294967277
[ 1279.624687] ath9k_config: Unable to set channel
[ 1279.916441] ath_set_channel: unable to reset channel 161 (5805Mhz)
flags 0x50142 hal status 4294967277
[ 1279.916586] ath9k_config: Unable to set channel
[ 1280.207274] ath_set_channel: unable to reset channel 165 (5825Mhz)
flags 0x10142 hal status 4294967277
[ 1280.207387] ath9k_config: Unable to set channel
[...]

- Steven
