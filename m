Return-Path: <linux-kernel-owner+w=401wt.eu-S1751497AbZGaBUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbZGaBUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 21:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbZGaBUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 21:20:23 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:29249 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750876AbZGaBUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 21:20:23 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: do_exit
Date: Thu, 30 Jul 2009 18:19:53 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501DCD047@exchange.ZeugmaSystems.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: do_exit
Thread-Index: AcoRfQHW08Qef/MKS66q4s3Mp5JdQw==
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

I have a small question regarding the function do_exit(). At the very
beginning of the function, it takes a reference (tsk) to "current" and
then it passes this reference to other functions. I am wondering where
there is any reason for not passing "current" directly in this case.
Does current gets clobbered/not trustable in this case? If we could pass
current directly, lot of the other functions could be cleaned up and
made to pass one less parameter.

Just curious.

Thanks

Ani

