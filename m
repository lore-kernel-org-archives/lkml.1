Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbZADSj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbZADSj2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZADSis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:38:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:2979 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZADSio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:38:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=e+VtQ9vaN0695YgWaTp0+rXNKwoqnNiPm8FLJuf355l6+lESlo3MRXbemCM+Xbzfk+
         wWIr9kyD69RUxJ+P9Y6/to/gx52e+/bBrF9rYG5gJJivHMsMdjUiHTSRJdMYeOdfQ/gv
         Xdu2EgtJcbn7rBtciOboS5G8OFnkPguKF+VeI=
Message-ID: <3f9a31f40901041038w47493205m9fcd87fe237ec257@mail.gmail.com>
Date: Mon, 5 Jan 2009 00:08:42 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH 2/4] fastboot: make scsi probes asynchronous
Cc: "Matthew Wilcox" <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20090104101353.05e8df09@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090104092430.7ffd2c41@infradead.org>
	 <20090104092940.11943797@infradead.org>
	 <20090104180515.GD2002@parisc-linux.org>
	 <20090104101353.05e8df09@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2009 at 11:43 PM, Arjan van de Ven <arjan@infradead.org> wrote:
>
> just checked;
> my box has CONFIG_SCSI_SCAN_ASYNC=y set for both cases
> it seems to be about 0.1 seconds win still though...
> sounds little, but a kernel boot should be less than a second, so that
> is still 10%. And it's obviously also disk dependent..
> (I used libata connected disks obviously)
>

Do you also have boot time numbers for RAM and/or flash based
filesystem (disk-less)

JSR
