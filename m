Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYGWMkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYGWMkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbYGWMkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:40:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:61715 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbYGWMka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Wbi+K/DLk3zcXSHYy8zKg1MiqGh2FhAwB93v1ZHZ3DVogyU3zNZEBu4WZW1aUoZsMl
         tHbpOhw6uDKcszmaavR31mKlBoJsFdWeYgKE8i4+h1QdXPlo95eGiWZzvRVGYIQ+Bn4U
         ogq2xL44bZwK470lECp1X7FbsmLiX5oppoFhw=
Message-ID: <a1d7a2f20807230540l4aa7e3f5i1511a2ea71fed8a9@mail.gmail.com>
Date: Wed, 23 Jul 2008 14:40:29 +0200
From: "Jerome Arbez-Gindre" <jeromearbezgindre@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: New IDX in linux/connector.h ?
Cc: linux-kernel@vger.kernel.org, deweerdt@free.fr
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

Nowadays, I'm working on a free software framework called TSP
(https://savannah.nongnu.org/p/tsp)
one of its components is a Blackboard (Aka BB).

It is simply a structured shared memory with named fields.
At the beginning, the BB was used to share/export data between two or
more userspace processes.
The blackboard also comes with messaging capabilities (which allows to
synchronize processes).

I'm working on a kernel port of the BB... and particularly on the
messaging feature.

My implementation is thus a user of your connector API

My request is the following:

Would it be possible to declare in linux/connector.h an IDX for the
BB, without any restriction on the VAL the BB could use?

We are willing to include the BB in-tree but this needs to be
discussed (in terms of usefulness) as the current kernel
implementation shares lots of code with the userspace implementations.

Thanks

          Jerome
