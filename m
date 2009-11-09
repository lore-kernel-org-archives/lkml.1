Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbZKJO21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbZKJO21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbZKJO20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:28:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:48941 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZKJO2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:28:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=otN3QkDdv/QgvlT6BTsluC5jPmaWlqfe/lM6xcu4l7pC9k3adci0UrxXXWt5z9JxkY
         j1Lmu1KzeGlMRrZyUW27puXqSr3ANEiabm1f+BA0LZxAd+bpbZQvWRpj8/mJwGsM+Edt
         B2qoxEaxd0RGzJgrXT0HvwPN070EVyypckuxg=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH 0/2] bsearch: fix overflow and avoid unnecessary calculation
Date: Mon,  9 Nov 2009 12:26:44 -0200
Message-Id: <cover.1257776095.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.153.g6e31f.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a rare overflow situation which can occur when working with large arrays.
Also, remove an unneeded calculation.

André Goddard Rosa (2):
  bsearch: avoid unneeded decrement arithmetic
  bsearch: prevent overflow when computing middle comparison element

 lib/bsearch.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

