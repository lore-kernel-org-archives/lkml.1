Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbYKVQjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbYKVQjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 11:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbYKVQjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 11:39:05 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:35482 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591AbYKVQjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 11:39:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=qSj5dMGtOMBXHhKxzW5YoRM9cfbWlCowcQ9fbaFvcxrfgX2Y6NbZRyAWwiidmZI1jO
         on1JgqnvpFudu6aABkDk23bDcMCUfiqHvNs+iAcxdaJFQOxmr00iSltrWK0D46v9wwNj
         2hFca/u1/D6ZmTOY7/vq1FQmmbz9cIC2xnNUc=
Message-ID: <e9c3a7c20811220839h20a5654bq8925392fcee86dbb@mail.gmail.com>
Date: Sat, 22 Nov 2008 09:39:01 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Stephen Hemminger" <shemminger@vyatta.com>
Subject: Re: next-20081121:WARNING: at drivers/dma/dmaengine.c:665 dma_async_device_unregister()
Cc: linux-kernel@vger.kernel.org,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
In-Reply-To: <20081121234359.767d4283@extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670811210240t77ec97d1pbe1ef0e4ae3a1a2e@mail.gmail.com>
	 <1227315224.32103.7.camel@dwillia2-linux.ch.intel.com>
	 <20081121234359.767d4283@extreme>
X-Google-Sender-Auth: 52065ae364883c74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 12:43 AM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> The warning is there for a reason. Device objects can live in sysfs even
> after the module is removed. You just wallpapered over the problem..

Indeed.  There are deeper issues with the dmaengine sysfs implementation...

Thanks,
Dan
