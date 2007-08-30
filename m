Return-Path: <linux-kernel-owner+w=401wt.eu-S1762558AbXH3UQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762558AbXH3UQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 16:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbXH3UQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 16:16:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:52462 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbXH3UQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 16:16:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qBKA9jgSl/djC/XJqkEB/UkNi2ffO87NvYyKo+8jPwU7PlqXUeYO4/3UXCez82xZ7MlzM0BBRDdrQLrIcLDLdW1U+9dScmvbRt9WUwc4vEGFlTKmr6KNX/Ny7erQres4vBpe0/YK/KLhdHseK9KJTN6MmPo8kDNDrEisEhrdVpM=
Message-ID: <38b2ab8a0708301316h45d83d9bkf5ba9a47e7b7eb00@mail.gmail.com>
Date: Thu, 30 Aug 2007 22:16:09 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: i2c transfers during interrupt context
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070830173232.270c6f70@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <38b2ab8a0708300311x5479effn5999ba118221a47f@mail.gmail.com>
	 <38b2ab8a0708300655n7ae6a445y84150ab1bdcdf2d4@mail.gmail.com>
	 <20070830173232.270c6f70@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bonjour Jean !

On 8/30/07, Jean Delvare <khali@linux-fr.org> wrote:
> Non. Tu n'as pas le droit de dormir dans un gestionnaire
> d'interruption, et la majorité des pilotes I2C dorment pendant les
> transferts.
>

Ok, c'est ce que je voulais savoir. Peut etre que cette regle pourrait
etre renforce par un "might_sleep()" ajoute dans les fonctions de
transfert de l'i2c-core ?

D'ailleurs pourquoi certains pilotes i2c ne dorment pas pendant les
transferts ? Qu'ont ils de different ?

> Si tu as besoin de faire ce genre de chose il faut typiquement passer
> par une workqueue.

Malheureusement dans certains cas la workqueue est schedulee trop
tardivement et le message i2c n'arrive pas a temps au device.

Une autre question, j'espere que je n'abuse pas: Comment peut on
changer la frequence du bus i2c depuis un driver ?

Merci pour tes reponses.
-- 
Francis
