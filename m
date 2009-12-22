Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZLVWSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZLVWSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 17:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZLVWR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 17:17:58 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:64987 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZLVWR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 17:17:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=S1yvaCm3e40dtWWdHmGIaDhwBm4n26JJ0PhY0dGsHrjuCRh/ArfZlaREOpEZl73HNq
         Yirm/OzCrITh7UYwy/o/cIaBn4CUQwPbu6S4UA5WHXjkbzG5SCOKz6qYaPFLrtqf0cLL
         ehS/UkqvGWLnAdJEz98ikpMMNE08E4BQMLoVs=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0912222130370.28669@ask.diku.dk>
References: <Pine.LNX.4.64.0912222130370.28669@ask.diku.dk>
Date: Tue, 22 Dec 2009 15:17:56 -0700
X-Google-Sender-Auth: 9b667042d112e97a
Message-ID: <e9c3a7c20912221417x46f85df5o73071a64428b5cbf@mail.gmail.com>
Subject: Re: [PATCH 1/6] drivers/dma: Correct use after free
From: Dan Williams <dan.j.williams@intel.com>
To: Julia Lawall <julia@diku.dk>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 1:30 PM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Move the kfree after the iounmap that refers to the same structure.
>

Thanks Julia.  I'll apply this one and the kzalloc versus memset one
you sent earlier.

--
Dan
