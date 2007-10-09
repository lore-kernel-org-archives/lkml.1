Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbXJIL5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbXJIL5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 07:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbXJIL5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 07:57:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:60703 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbXJIL53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 07:57:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ubFBVKede6HzR5fInnlSmN2xi0WjoSSiORS7LahbQcQ76xYKjN9kqnUdVaS0p44/vIX/bswnkwBkPdAwbSBbl6WO1Ypi5l1pIUGDV1GABUvuthQj8lJYsUcJ+Xk0xk6yKFdGVWqMtK54UHsMC8h8lPH275SJnNVTTn0QN+On2E0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Malte =?iso-8859-15?q?Schr=F6der?= <maltesch@gmx.de>
Subject: Re: Strange network related data corruption
Date: Tue, 9 Oct 2007 12:57:20 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <20071007184741.3b1951c1@highlander.home.lan> <200710081401.32375.vda.linux@googlemail.com> <20071009132553.439f7d8b@cp771133>
In-Reply-To: <20071009132553.439f7d8b@cp771133>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710091257.20874.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007 12:25, Malte Schröder wrote:
> > Does it happen over loopback?
> 
> I just tried a few times and yes, it also happens on loopback, but
> much less frequently. Now I am really confused ...

Actually, that eliminates a lot of cases.

Run memtest86 overnight ("bad hardware" theory),
try older kernel versions ("kernel bug" theory).
--
vda
