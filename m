Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbZLRIwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbZLRIwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 03:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZLRIwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 03:52:12 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51479 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZLRIwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 03:52:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JPvcplsf9k8KOUtN6vKqQfAXeQT85z10mKcoDyKmWcFUOh218NECeFlMTWxsc2zCVl
         D2S0j5XbBYlGr7IJ6eUSbHDNvRR5rs1wvrpYQR3WLQVBBJe9gvZKai1r4C1wnUxFLKME
         M1+YakW96ktzGjEkg+S8XxEKI04G9fUKaN56I=
Message-ID: <4B2B42B6.1010501@gmail.com>
Date: Fri, 18 Dec 2009 08:52:06 +0000
From: Lukasz Sokol <el.es.cr@googlemail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Rfkill buttons : bi-stable, mono-stable, tactile
References: <loom.20091217T122606-341@post.gmane.org> <20091217150709.GA6375@srcf.ucam.org> <loom.20091217T161042-883@post.gmane.org> <20091217195231.GA11747@srcf.ucam.org>
In-Reply-To: <20091217195231.GA11747@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> (Please keep me Cc:ed - linux-kernel is high enough traffic that it's 

Ok, sorry, I was posting through gmane's web interface, I like it quite, but it is stupid
in the sense that it does not keep cc:s...

>> i.e. the rfkill does not know, and the 'problem' is only noticed when the wifi
>> disassociates (but Network Manager tries on to reconnect). On the other hand,
>> invoking /sbin/rfkill [un]block wifi blocks/unblocks wifi comfortably.
> 
> What does ls -l /sys/class/rfkill look like? What driver are you using 
> for your wireless card?
> 

lrwxrwxrwx 1 root root 0 2009-12-17 20:30 rfkill0 -> ../../devices/pci0000:00/0000:00:1c.2/0000:03:00.0/ieee80211/phy0/rfkill0

lukasz@workhorse:~$ lsmod |grep 802
mac80211              181140  1 ath5k
cfg80211               93052  3 ath5k,mac80211,ath

rfkill is built in (i.e. not a module) in this kernel, I heard somewhere.

Lukasz
