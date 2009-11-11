Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbZKKASp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbZKKASp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZKKASp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:18:45 -0500
Received: from ozlabs.org ([203.10.76.45]:37157 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZKKASo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:18:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?utf-8?q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>
Subject: Re: [PATCH v3 2/2] bsearch: prevent overflow when computing middle comparison element
Date: Wed, 11 Nov 2009 10:48:46 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org
References: <cover.1257778258.git.andre.goddard@gmail.com> <d748022cff75d9c09afc93b77cb16a683136cd13.1257778258.git.andre.goddard@gmail.com>
In-Reply-To: <d748022cff75d9c09afc93b77cb16a683136cd13.1257778258.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911111048.46705.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 02:12:31 am André Goddard Rosa wrote:
> It's really difficult to occur in practice because the sum of the lower
> and higher limits must overflow an int variable, but it can occur when
> working with large arrays. We'd better safe than sorry by avoiding this
> overflow situation when computing the middle element for comparison.

I always thought the obvious answer was:

	mid = start + (end - start)/2;

Your version does nothing for 32 bit platforms...
Rusty.
