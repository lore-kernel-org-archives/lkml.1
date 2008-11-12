Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbYKLJTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbYKLJTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 04:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYKLJS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 04:18:59 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:36374 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYKLJS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 04:18:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=c5Y9Qdlhjd+LdOjfd8DfRpgwlYq0yXyzbDEfEwXjWg9dzp9n8RNyOE+vyP9ymyr2JX
         BgoMcs4LaorYVuUSrvH8enfbRSELnJZpt3kd7U02fXkGR0Eviio+LJpiIgpTx7O3uMMq
         RczDrMTIFtC7rMQ67NwQd7W2cyIpF7U8Wx4Ao=
Message-ID: <2f3bf9a60811120118n6c16760eke1f6254b278e5b5c@mail.gmail.com>
Date: Wed, 12 Nov 2008 11:18:55 +0200
From: "Dotan Barak" <dotanba@gmail.com>
To: andyw@uk.ibm.com
Subject: false error in checkpatch version 0.24
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

When i execute checkpatch version 0.24 of a file which contains the
following line:
  return a * b;

It complains with the following error message:
ERROR: space prohibited after that '*' (ctx:WxW).

I think that this may be a false error.
(maybe it fail on a rule which handles pointers declaration).

Thanks
Dotan
