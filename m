Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbZBZRB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbZBZRB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 12:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbZBZRBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 12:01:21 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:60444 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbZBZRBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 12:01:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=NgboCJ1ifH7OVdTJFwI0jcYc0Veo0T/IpmwOhbzAJu2TFybEo7z1n+qhq5onkgOl7m
         JBtnDkPAbQI1D5qzAZHpwRceNh4kg4hfs/Lm/CkuHu06JN3VHCYq5YXeh6oozORr1FPq
         1fOIPzdTOm78OG87ef+2sEIwrZvd1iVdjPteo=
From: Diego Calleja <diegocg@gmail.com>
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Subject: Re: Failover Kernel
Date: Thu, 26 Feb 2009 18:02:56 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-00315-g683fdc5; KDE/4.2.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <49A659D0.2040903@turknet.net.tr>
In-Reply-To: <49A659D0.2040903@turknet.net.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-9"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902261802.56612.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jueves 26 Febrero 2009 09:58:56 Tarkan Erimer escribió:
> Hi all,
> 
> I'm thinking about a kernel feature called "Failover Kernel". The basic 
> idea is to put 2 kernels (One is running "Primary Kernel" and the next 
> one is "Backup Kernel") into the memory for disaster recovery of kernel 
> panic'ing/crashing.

Isn't this what kdump does right now? http://lwn.net/Articles/108595/
