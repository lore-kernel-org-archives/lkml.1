Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbZKLJrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbZKLJrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 04:47:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZKLJrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 04:47:05 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45891 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZKLJrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 04:47:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AI0Leg4V7Lq0GNUDcIDOjcwffU61vMJu+UtAkLscenXlMG3G6jWMGqtyK4mYPhrWS3
         TcPkIj83gWm99Dfj/ZkJLmq3FfP7wdQ0DleVteWDIUFFVNIn+A2QTNIZ3SPZOHBOgdMJ
         5XY4cMnzXBs2McNyzsJtflym0CWrYxDuijsRs=
MIME-Version: 1.0
In-Reply-To: <20091112081043.GA25345@elte.hu>
References: <4AFB2C0B.50605@gmail.com>
	 <20091111134730.a0da9e38.akpm@linux-foundation.org>
	 <20091112081043.GA25345@elte.hu>
Date: Thu, 12 Nov 2009 12:47:09 +0300
Message-ID: <b6fcc0a0911120147p7d23dc14q81a27e9742888c57@mail.gmail.com>
Subject: Re: [patch] Fix: 'return -ENOMEM' instead of 'return ENOMEM'
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/09, Ingo Molnar <mingo@elte.hu> wrote:
>  drivers/scsi/aic7xxx/aic7xxx_osm.c:             return ENOMEM;         # works but weird

"weirdness" comes from BSD where E codes are negative,
so they do not have this problem at all.
