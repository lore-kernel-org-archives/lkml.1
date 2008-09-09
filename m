Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbYIIHeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbYIIHeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYIIHea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:34:30 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:49207 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbYIIHe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=um/GEuSm1jx/vfNRV65tXtqnf4y9wPpQzliKhf2/incvZBRVjriEnqtWqK+fkgGHWt
         7Av3MpKXXDPTUhHjtA6QlUezcrkUiSrrEQpXU8ytmtAmDrlW36SXfSu1ISXbNg7yetzJ
         3hdaPdxmnuK9tPSsRTp3N2XAGEQIa4ndfHG5o=
Message-ID: <5ff4a1e50809090034y3156427bpfac8a07674c3c844@mail.gmail.com>
Date: Tue, 9 Sep 2008 08:34:27 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
In-Reply-To: <20080909092216.46a6eba1@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
	 <20080907123832.5ba79c12@mjolnir.drzeus.cx>
	 <5ff4a1e50809080628i65bd7c7blfac70659a9f9229c@mail.gmail.com>
	 <20080909092216.46a6eba1@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/9 Pierre Ossman <drzeus-mmc@drzeus.cx>:
> On Mon, 8 Sep 2008 14:28:00 +0100
> "Matt Fleming" <mattjfleming@googlemail.com> wrote:
>
>> You're right, I changed the patch accordingly (I also fixed the read
>> timeout path).
>>
>
> This still doesn't use the fields from the request structure. E.g. SDIO
> support is probably still broken here as it mandates a timeout of 1
> second for data transfers.
>

What fields in the request structure? Are you talking about struct mmc_request ?
