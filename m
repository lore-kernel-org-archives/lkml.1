Return-Path: <linux-kernel-owner+w=401wt.eu-S934112AbZDAVWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112AbZDAVWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765526AbZDAVWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:22:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:52716 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbZDAVV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:21:59 -0400
MIME-Version: 1.0
In-Reply-To: <20090401174336.GA14726@srcf.ucam.org>
References: <200903291224.21380.info@gnebu.es> <200903311452.05210.info@gnebu.es> 
	<20090331134547.GJ13356@mit.edu> <200904010002.47077.info@gnebu.es> 
	<49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu> 
	<20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> 
	<20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org>
Date: Wed, 1 Apr 2009 14:21:43 -0700
Message-ID: <2c0942db0904011421w58c0c2dyb70235fb739cbd30@mail.gmail.com>
Subject: Re: Ext4 and the "30 second window of death"
From: Ray Lee <ray-lk@madrabbit.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 1, 2009 at 10:43 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> I've got absolutely no idea why anyone would want fsync() to stop
> meaning "Put my data on the disk please".

Some guy named Andrew used to run a kernel with 'return 0' at the top
of fsync and fdatasync: http://lkml.org/lkml/2007/4/27/88

It's that the latency penalty of apps using *sync() on common hardware
sucks. That's all, and finding a way to fix that would make this
entire thread go away, I think.
