Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbYJMQ3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbYJMQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYJMQ3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:29:18 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:40462 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbYJMQ3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:29:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OUoTmZGEzSklIwdkmlW3mZGzrDzPSj8zVZlB2+Os4uQ9syCkZOTPna7vuTroitIKkU
         2H810rdf52E1NGFsMda3EEo23prmC899+MU5jkgIksI4ArFFN52MQ5/nl3cPXQJft6HD
         4HKFC7Sif5CXapbOqVWL9VUkKIW/pdJ84Dj7s=
Message-ID: <912ec82a0810130929h42574fav985e922ad019b8f5@mail.gmail.com>
Date: Mon, 13 Oct 2008 18:29:16 +0200
From: "Neshama Parhoti" <pneshama@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: section mismatch with a platform driver
Cc: "Adrian Bunk" <bunk@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081013090133.a58116a2.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com>
	 <20081013085111.GB29938@cs181140183.pp.htv.fi>
	 <912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>
	 <20081013090133.a58116a2.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 6:01 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> A probe function can be called at any time -- i.e., after system init
> has completed, so discarding the __init function my_probe_func() is BAD,
> dangerous, BUGgy.

Thanks for the explanation!

Does that mean that all drivers with __init in their probe functions are bogus ?

>
> ---
> ~Randy
>
