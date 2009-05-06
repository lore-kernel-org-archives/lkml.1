Return-Path: <linux-kernel-owner+w=401wt.eu-S1760460AbZEFO7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbZEFO7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbZEFO6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:58:47 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:44855 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbZEFO6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:58:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=L05/qaUzxfUA+ub9w1qQH5aBUDsDlLI+ELYqrAZW5HAcz3H9V4bBHWp2GmVytgftck
         rd78j1ekihe4p6rac0bqXXyTjNFBeecmgHs0frSzD5LCadN8PPOJI8dmuv2hk7ushLMO
         IAO2L6VGjgzpE9vNRPk+8JQjwD8nWC6DaRSYw=
MIME-Version: 1.0
Date: Wed, 6 May 2009 18:58:44 +0400
Message-ID: <a4423d670905060758x32774671o796ae46fbb43997c@mail.gmail.com>
Subject: next: parport: forgotten semicolon
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Greg KH <gregkh@suse.de>, linux-next <linux-next@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg

Please fix parport-remove-driver_data-direct-access-of-struct-device.patch

-       struct parport *p = dev_get_drvdata(&dev->dev)
+       struct parport *p = dev_get_drvdata(&dev->dev);
