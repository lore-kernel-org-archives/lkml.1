Return-Path: <linux-kernel-owner+w=401wt.eu-S932188AbZDXRzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbZDXRzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761296AbZDXRze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:55:34 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:42082 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761379AbZDXRzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:55:32 -0400
Message-ID: <49F1FD4B.2020909@oracle.com>
Date: Fri, 24 Apr 2009 10:56:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for April 24 (p54 build error)
References: <20090424150456.ff35e4ea.sfr@canb.auug.org.au>
In-Reply-To: <20090424150456.ff35e4ea.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49F1FD0B.02C6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/net/wireless/p54/p54.h:193: error: array type has incomplete element type

struct p54_led_dev definition is controlled by
#ifdef CONFIG_P54_LEDS (is not set)

but the struct declaration is controlled by
#ifdef CONFIG_MAC80211_LEDS (=y)


-- 
~Randy
