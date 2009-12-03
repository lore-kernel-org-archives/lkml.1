Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbZLCTAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbZLCTAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbZLCTAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:00:55 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:50790 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501AbZLCTAy (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 3 Dec 2009 14:00:54 -0500
Date: Thu, 3 Dec 2009 13:56:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: jayakumar.lkml@gmail.com, damm@opensource.se, linux-kernel@vger.kernel.org,
       armbru@redhat.com
Subject: Re: [PATCH 1/3] fb-defio: If FBINFO_VIRTFB is defined, do not set
	VM_IO flag.
Message-ID: <20091203185606.GB17342@phenom.dumpdata.com>
References: <1259854318-16907-1-git-send-email-konrad.wilk@oracle.com> <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com> <4B180867.3050706@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B180867.3050706@goop.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B180AD5.01D1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 10:50:15AM -0800, Jeremy Fitzhardinge wrote:
> On 12/03/09 07:31, Konrad Rzeszutek Wilk wrote:
> > Most users (except sh_mobile_lcdcfb.c) get their framebuffer from
> > vmalloc. Setting VM_IO is not necessary as the memory obtained
> > from vmalloc is System RAM type and is not susceptible to PCI memory
> > constraints.
> >   
> 
> Looks good, but you forgot signoffs on these.  Do you want me to add them?

Duh!! Please do. Thank you for noticing it.
