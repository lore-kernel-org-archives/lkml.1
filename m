Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZGXTFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZGXTFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 15:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbZGXTFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 15:05:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:41176 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZGXTFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:05:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=m3u0/Bb/9zxWhVkwHb+qZIgLhJM70a86SyjGlg0U5S3eUBaAurxWsn0A+SSlenh5c
	tQ2/KpOnU9SAUPWPm4flw==
MIME-Version: 1.0
In-Reply-To: <20090724100807.GG11101@hawkmoon.kerlabs.com>
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com>
	 <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com>
	 <20090724100220.GF11101@hawkmoon.kerlabs.com>
	 <20090724100807.GG11101@hawkmoon.kerlabs.com>
Date: Fri, 24 Jul 2009 15:05:29 -0400
Message-ID: <2f86c2480907241205m68b93268tfdf343f76b410bac@mail.gmail.com>
Subject: Re: [PATCH 5/6] Makes procs file writable to move all threads by tgid 
	at once
From: Benjamin Blum <bblum@google.com>
To: Ben Blum <bblum@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com, lizf@cn.fujitsu.com, menage@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 6:08 AM, Louis Rilling<Louis.Rilling@kerlabs.com> wrote:
> Patch 6 should really go before this one, both for
> better understanding and safety.
>
> Thanks,
>
> Louis
>

I agree. I wrote patch 6 after patch 5 and didn't bother reworking the
code a bit to make it come first. I'll switch them around in the next
submission.
