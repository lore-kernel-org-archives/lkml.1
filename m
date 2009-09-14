Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbZING1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbZING1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 02:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbZING1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 02:27:34 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:43727 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZING1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 02:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=N9f4ibGLc0MHV+DyVGI65sknRu/gduy0RFhor3rZdddTZSCyL9qfW2Smt8mR21tSWg
         RLWKZPJpqDbDdLub1eeiYR0a/me5pFmVlnyQCrJI2CRm686D+TuOxGux6QaX+spS3mdZ
         W0HPdcHDtRX6kdx/ztnxzT/R89Mf29XgoprQk=
MIME-Version: 1.0
In-Reply-To: <4AADBB77.5050803@redhat.com>
References: <1252866835.13780.37.camel@dhcp231-106.rdu.redhat.com>
	 <1252883493.16335.8.camel@dhcp231-106.rdu.redhat.com>
	 <4AADBB77.5050803@redhat.com>
Date: Mon, 14 Sep 2009 09:27:36 +0300
X-Google-Sender-Auth: b40866308a4173db
Message-ID: <84144f020909132327u701bde60ibc558eb91ca2b391@mail.gmail.com>
Subject: Re: [GIT BISECT] BUG kmalloc-8192: Object already free from 
	kmem_cache_destroy
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Danny Feng <dfeng@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, cl@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 6:41 AM, Danny Feng <dfeng@redhat.com> wrote:
> That's my fault... Please drop this patch, I didn't notice the free action
> in kobject release phase.. Thanks for point it out.

Dropped, thanks Eric!
