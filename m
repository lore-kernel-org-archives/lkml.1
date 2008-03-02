Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbYCBRBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbYCBRBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 12:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbYCBRBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 12:01:44 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:14962 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbYCBRBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 12:01:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VDnjynxF646pBVPTl1JHg3NVyWaOy7xjBPBLscmX8QqrfO0kiwzs5aLyK09VfwJMuYwcGbUAiLVyKhHfHIPFjxwQvLteMxZt+vKjfYZg0tQ/TWj3Futm4wSur1qdA0XAVXuRbtggE15DSjiJuoupqZkg1ipy2e+C8FE0CJvlCuA=
Message-ID: <2f11576a0803020901n715fda8esbfc0172f5a15ae3c@mail.gmail.com>
Date: Mon, 3 Mar 2008 02:01:40 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Rick van Rein" <rick@vanrein.org>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080302134221.GA25196@phantom.vanrein.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080302134221.GA25196@phantom.vanrein.org>
X-Google-Sender-Auth: 6a6bdab15e6bd18e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

in general,
Agreed with we need bad memory treatness.

>  +#define PG_badram              20      /* BadRam page */

some architecture use PG_reserved for treat bad memory.
Why do you want introduce new page flag?
for show_mem() improvement?
