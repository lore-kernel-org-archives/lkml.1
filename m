Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbYCaSSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbYCaSSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYCaSSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 14:18:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37510 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753431AbYCaSSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 14:18:11 -0400
Date: Mon, 31 Mar 2008 13:18:08 -0500
From: Paul Jackson <pj@sgi.com>
To: "Bert Wesarg" <bert.wesarg@googlemail.com>
Cc: travis@sgi.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: modify show_shared_cpu_map in intel_cacheinfo
Message-Id: <20080331131808.e21d494f.pj@sgi.com>
In-Reply-To: <36ca99e90803311024h6aeb89beyd72f73c3763c0a9c@mail.gmail.com>
References: <20080327231654.284673000@polaris-admin.engr.sgi.com>
	<20080327231654.599276000@polaris-admin.engr.sgi.com>
	<36ca99e90803280201i708ce9b7y293a2c68e733f088@mail.gmail.com>
	<47ED0343.1070708@sgi.com>
	<36ca99e90803280754p1fbedbccp366366f0240fe5cc@mail.gmail.com>
	<47ED36B9.6000508@sgi.com>
	<36ca99e90803290159v33ab43cbu5acd4bc2b0cd0262@mail.gmail.com>
	<47F112BD.4050801@sgi.com>
	<36ca99e90803311024h6aeb89beyd72f73c3763c0a9c@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert wrote:
> Sure your list is mostly shorter than a hex mask

"mostly" -- yup.

The masks always take 9 chars per 32 bits of the full mask size
(whether zeros or ones.)

The lists can take up to approx one to three chars per bit, for the
worst case lists of every other bit, depending on the log base 10 of
the highest included bit.

Consider for example:

  97,99,101,103,105,107,109,111,113,115,117,119,121,123,125,127

vs.

  AAAAAAAA,00000000,00000000,00000000

which, if I did my math right, are the same value.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
