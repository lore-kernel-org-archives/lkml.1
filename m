Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZKBRIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZKBRIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbZKBRII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:08:08 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:46555 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbZKBRIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:08:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=B/qzuxxUUzAIkO9RXE3xTBBTSjHKSNaeqhj9cW5Tu0Yl/EHJNdaaqvB3xH68ptRV0l
         KvTZIq4X8EfrrCoRgU1oGKXV6KZmyW02r9KRLQiqWFMuR7pPFT3NpdE+HeL+sOXzpS87
         UL20ZVA7wvuAAhzg4VEFgdkIiSLbNLXpOQ+is=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 2 Nov 2009 09:07:52 -0800
Message-ID: <43e72e890911020907m7cfc48edpd300243de7af36ed@mail.gmail.com>
Subject: Kmemleak for mips
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: subscriptions@stroomer.com, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Curious what the limitations are on restricting kmemleak to non-mips
archs. I have a user and situation [1] where this could be helpful [1]
in debugging an issue. The user reports he cannot enable it on mips.

[1] http://bugzilla.kernel.org/show_bug.cgi?id=14502

  Luis
