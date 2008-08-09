Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbYHIVHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbYHIVHf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYHIVH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:07:27 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42704 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751330AbYHIVH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:07:26 -0400
Date: Sat, 9 Aug 2008 16:07:21 -0500
From: Paul Jackson <pj@sgi.com>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Cc: menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup.c: Some 'hlist_head' function fixes.
Message-Id: <20080809160721.320b114d.pj@sgi.com>
In-Reply-To: <b9df5fa10808080829l6275a208u65b3c48dafe6c8e1@mail.gmail.com>
References: <b9df5fa10808080829l6275a208u65b3c48dafe6c8e1@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rabik wrote:
> +	i = 0;
> +	i = hash_long(tmp, CSS_SET_HASH_BITS);

That "i = 0;" looks unnecessary to me, given
that i is unconditionally set again, on the
very next line.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
