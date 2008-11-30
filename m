Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYK3VCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYK3VCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 16:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbYK3VCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 16:02:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:44787 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435AbYK3VCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 16:02:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=cafkcOW4Th6GOKQZY8HhQFeK8XnihJUEQ7eUh1GMrHOGzAt0qDgcFE/VIvvjFxxfbx
         nGtc6tsEysHrfht66PApqM44QORD88Cn2/4ArJWV7xdLA1PiD3/nVqUohLLZSKgZxFXC
         6hobxFxpZxl9ohHKLKWvSzTsewdUSKL1mbXg0=
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
From: Remi Colinet <remi.colinet@gmail.com>
Reply-To: remi.colinet@gmail.com
To: Greg KH <greg@kroah.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081129234907.GA2340@kroah.com>
References: <1227980689.6354.24.camel@localhost.localdomain>
	 <20081129214207.GA6747@x200.localdomain>  <20081129234907.GA2340@kroah.com>
Content-Type: text/plain
Organization: Personal
Date: Sun, 30 Nov 2008 22:00:11 +0100
Message-Id: <1228078811.2658.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-29 at 15:49 -0800, Greg KH wrote:
> On Sun, Nov 30, 2008 at 12:42:07AM +0300, Alexey Dobriyan wrote:
> > On Sat, Nov 29, 2008 at 06:44:49PM +0100, Remi Colinet wrote:
> > > This patch add a new /proc/mempool file in order to display mempool usage.
> > > 
> > > The feature can be disabled with CONFIG_PROC_MEMPOOL=N during kernel
> > > configuration.
> > 
> > We're NOT adding config option per proc file.
> > 
> > And can we, please, freeze /proc for not per-process stuff and open debugfs
> > for random stuff, please?
> 
> debugfs has been open for random stuff since the day it was added to the
> tree :)
> 
> Feel free to put this kind of thing there instead of proc.
> 

Acknowledged,

> thanks,
> 
> greg k-h

Thanks,
Remi

