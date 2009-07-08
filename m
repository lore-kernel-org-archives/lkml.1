Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZGHKTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZGHKTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZGHKTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:19:15 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56288 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZGHKTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Wp72+3souDYwpJd64SD9Ku3g3Mk+HoexeNOeqeSU7mtZHBhBD/RPnVru0cu8dhmCta
         FrdrOHhT+ByRGRm31RoI5RZt2DQMNEqwJsYcQaeMGa/OuuhP9MNFLUBLsLP0mzm0oW3s
         K0/qDDCHF5zs2kFMqCNyiO4bj5FOY9+ZeNbaU=
MIME-Version: 1.0
Date: Wed, 8 Jul 2009 12:19:10 +0200
Message-ID: <b08bcbf50907080319q4ba2315chd116a39162ba1023@mail.gmail.com>
Subject: Passive wait for netif_queue_stopped() ?
From: Gallus <gall.cwpl@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
is it possible to wait passively for netif_queue_stopped? Currently
I'm doing something like:

while(netif_queue_stopped(..)) retry_count++;

Please CC me.

Regards,
Gallus
