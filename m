Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbYJMMXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbYJMMXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 08:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbYJMMXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 08:23:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3390 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbYJMMXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 08:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=yHcuVX2LcGksx3ZboltuyITidQE2CkyZVzESnaNFDadDk03qbg4hIf97qXkrGmOCzT
         UyukBjUFdOhsD//8Rm7pbCSVcBsLdGglPNvdgCR0xwvZ4fnm5y2TaRVWCHD1GR9jwMZ8
         0pJrjxtRYuKgXetrZqkyAJwoCLOtwJTn1N/kU=
Message-ID: <c62985530810130523n3656c937taf2dfc48b237520a@mail.gmail.com>
Date: Mon, 13 Oct 2008 14:23:21 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [RFC][PATCH] tty: remove the BKL in n_tty.c
Cc: "Ingo Molnar" <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <874p3gsrvt.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081013084719.03972D1B9DE@perso1.free.fr>
	 <874p3gsrvt.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/13 Andi Kleen <andi@firstfloor.org>:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> I suppose Alan did it already, but the general rule when doing
> such changes is to lock data not code.

Ah ok. But there are so much references to tty->column on these functions
so that I thought the best thing to do was to lock the whole path.

Thanks.
