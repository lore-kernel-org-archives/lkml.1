Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZHQILa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZHQILa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbZHQILa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:11:30 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:56134 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208AbZHQIL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ICaQxnZex6z1J7yH8dYef8NWv8MoPes3jj+xWToCpeOLNKcVdp3oLUqZhP1SZQP6Ny
         ZxwqllzwaWYHd/Dbp+ZpvU49EVjWU8TWwSBfX7A0bReguMd9PHe/uIybFrs6XIqjs07S
         EYX+lb97RRv+RVz2rg5zrbcVX1nZ3YL3dnWlg=
Message-ID: <4A8910B0.1050509@gmail.com>
Date: Mon, 17 Aug 2009 10:11:28 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: akpm@linux-foundation.org, andi@firstfloor.org, rpjday@crashcourse.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] VIDEO: console, use DIV_ROUND_UP
References: <20090817073147.GA2967@localdomain.by> <1250495293-13035-1-git-send-email-jirislaby@gmail.com> <20090817080023.GB2967@localdomain.by> <4A890E33.2080302@gmail.com> <20090817080853.GC2967@localdomain.by>
In-Reply-To: <20090817080853.GC2967@localdomain.by>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2009 10:08 AM, Sergey Senozhatsky wrote:
> Oops, silly me. Somehow I thought about
> DIV_ROUND_UP((vc->vc_font.width + 7) , 8). My fault. Sorry.

No problem at all. We converged our thoughts, that's success.
