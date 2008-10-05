Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbYJELgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbYJELgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 07:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYJELgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 07:36:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:62693 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbYJELgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 07:36:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J4DwFOt3lS6E0PtCW0Dw0w1WPRLnlempfRBes9EWNJ4jkv/iLygo3/LOSSWdC/z8iM
         rmP3xyA5+osYauWLyPPvnKjvCIm2tZHxlpEk7CGl+fo+A+10h3ublNbl46D2E9fnorq6
         Xu46N56+6VrL7bmcptF+Qtopb0ue3U0w5pVZA=
Message-ID: <c62985530810050436v38349e2aw6ceec333f2347571@mail.gmail.com>
Date: Sun, 5 Oct 2008 13:36:02 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [patch] fix printk format typo in boot ftracer.
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20081004172449.58e53afd@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081004134227.465fa20c@infradead.org>
	 <c62985530810041358p1cc361b1te89894cedcd7e3b3@mail.gmail.com>
	 <20081004172449.58e53afd@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/5 Arjan van de Ven <arjan@infradead.org>:
> it's more than precision, it's correctness.
>
> doing "0.%02i" will do
> 0.100  if you pass it 100 and
> 0.10   if you pass it 10
>
> and most off the time, except the first 0.1 seconds, you'll be passing
> it 9 digits, but the first 0.1 seconds.. the %06 will just give really
> incorrect results.

That's right indeed.

Thanks!
