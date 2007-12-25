Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbXLYXgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbXLYXgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 18:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXLYXf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 18:35:58 -0500
Received: from ozlabs.org ([203.10.76.45]:51168 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbXLYXf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 18:35:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 02/16] adapt lguest launcher to per-cpuness
Date: Wed, 26 Dec 2007 10:35:46 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lguest@ozlabs.org, glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rostedt@goodmis.org
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com> <11981576492807-git-send-email-gcosta@redhat.com>
In-Reply-To: <11981576492807-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712261035.46939.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2007 00:33:42 Glauber de Oliveira Costa wrote:
> +		if (!vcpu_id) {
> +			/*
> +			 * Service input, then unset the BREAK to
> +			 * release the Waker.
> +			 */
> +			handle_input(lguest_fd);
> +			if (pwrite(lguest_fd, args, sizeof(args), 0) < 0)
> +				err(1, "Resetting break");
> +		}

I hate winged comments: those two extra lines, wasted!

Cheers,
Rusty.

