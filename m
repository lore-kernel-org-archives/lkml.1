Return-Path: <linux-kernel-owner+w=401wt.eu-S1762036AbZDGWf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036AbZDGWf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757883AbZDGWfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:35:48 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:8883 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZDGWfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=TFf/T/OXBk//iJ0MtK2IYB4xKqOTp0qPXjV1S2nQyrJYcYlXCr3NFzT9JppySpjVoq
         Gl8T1SJxm81A1FPiUIKtvHwcYbdImFqYaGzqmnu1OUwtEliz5GXlRZ0kuBR3k1mf347e
         iH0CmrAr2mIX3Gn8M5zfy/NDG6aTdOT+9m8Nc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
Date: Wed, 8 Apr 2009 00:35:16 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-10247-g8e2c4f2-dirty; KDE/4.2.1; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@redhat.com,
       David Woodhouse <David.Woodhouse@intel.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <200904072339.00224.bzolnier@gmail.com> <20090407221554.GA4527@linux.intel.com>
In-Reply-To: <20090407221554.GA4527@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904080035.16457.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 April 2009 00:15:54 Matthew Wilcox wrote:
> On Tue, Apr 07, 2009 at 11:38:59PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > I would like to see this merged for -rc1 so I tried to put it altogether
> > and then integrate it over recent IDE and block changes...
> 
> You're missing 1/5 and 2/5.  This patch will crash horribly if you use
> it with a drive which supports TRIM.

Heh, I knew something was out of place...
