Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbYCOFKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbYCOFKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 01:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbYCOFKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 01:10:04 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:37865 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYCOFKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 01:10:02 -0400
Date: Sat, 15 Mar 2008 06:09:17 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/5] make more ntp values static
In-Reply-To: <1205554501.6122.92.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0803150607380.1791@scrub.home>
References: <1205553852.6122.76.camel@localhost.localdomain> 
 <1205553938.6122.79.camel@localhost.localdomain>  <1205554018.6122.81.camel@localhost.localdomain>
  <1205554210.6122.85.camel@localhost.localdomain> 
 <1205554366.6122.88.camel@localhost.localdomain> <1205554501.6122.92.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 14 Mar 2008, john stultz wrote:

> Make time_status, time_maxerror and time_esterror static to ntp.c

time_maxerror and time_esterror are ok, but ntp_synced() is such a small 
function, I'd rather keep it inlined.

bye, Roman
