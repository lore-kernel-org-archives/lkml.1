Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbZBUTTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbZBUTTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 14:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZBUTTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 14:19:01 -0500
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:38759 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbZBUTTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 14:19:01 -0500
Date: Sat, 21 Feb 2009 20:18:57 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED && PACTH AVAILABLE] [drm:i915_initialize] *ERROR* can
 not ioremap virtual address for ring buffer
Message-ID: <20090221201857.3b788680@fastwebnet.it>
In-Reply-To: <20090221150840.GA28370@silver.sucs.org>
References: <20090221110011.030cb16d@fastwebnet.it>
	<20090221121944.GA21090@silver.sucs.org>
	<20090221134933.368c2709@fastwebnet.it>
	<20090221135233.58fbae0b@fastwebnet.it>
	<20090221130521.GA13134@silver.sucs.org>
	<20090221131209.GB13134@silver.sucs.org>
	<20090221155706.5f6d2184@fastwebnet.it>
	<20090221150840.GA28370@silver.sucs.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Feb 2009 15:08:41 +0000
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> > [  156.729311] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 1  
> 
> Me too. If you are using kernel modesetting then it is probably
> http://marc.info/?l=linux-kernel&m=123497969008792&w=2 . There's also a
> chance that it is related to
> http://bugzilla.kernel.org/show_bug.cgi?id=10628 (which was fixed by
> reverting). 

No, I'm not using KMS.

-- 
	Paolo Ornati
	Linux 2.6.29-rc5-00276-g2ec77fc-dirty on x86_64
