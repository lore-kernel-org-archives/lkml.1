Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369Ab0AQSXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0AQSXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285Ab0AQSXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:23:42 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62510 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab0AQSXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hNa9NyBCjd9JQWGrd7sw2Lt/XO4ypmtx9nbvTYXfaetG3cY6VWsJv4s4d7K6bosUdI
         WmKYm54vJY3lo1kCFbNk0urByNsolIAswtFx+eawsSQ6MtXHCc2ujzYcHBFNfppzVWCj
         1bbJXhbBw7/iPq4n51pKaZzUpHdNRLox2su1I=
MIME-Version: 1.0
Date: Sun, 17 Jan 2010 20:23:38 +0200
Message-ID: <b6fcc0a1001171023h5b8ce32w7970430ebf38950c@mail.gmail.com>
Subject: Re: [PATCH 1/1] Constify struct sysfs_ops for v2.6.33-rc4
From: Alexey Dobriyan <adobriyan@gmail.com>
To: re.emese@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -        ssize_t (*show)(struct kobject *, struct attribute *, char *);
> -        ssize_t (*store)(struct kobject *, struct attribute *, const char *);
> +        ssize_t (* const show)(struct kobject *, struct attribute *, char *);
> +        ssize_t (* const store)(struct kobject *, struct attribute *, const char *);

I thought people were against this part.
