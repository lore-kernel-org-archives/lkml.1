Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbZKMWis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbZKMWis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbZKMWip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:38:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40746 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252AbZKMWip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:38:45 -0500
Message-ID: <4AFDDFF3.2070601@zytor.com>
Date: Fri, 13 Nov 2009 14:38:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 2/3] vc: Add support for hiding the cursor when creating
 VTs
References: <1258142222-16092-1-git-send-email-mjg@redhat.com> <1258142222-16092-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1258142222-16092-2-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2009 11:57 AM, Matthew Garrett wrote:
>  
>  static int con_open(struct tty_struct *, struct file *);
>  static void vc_init(struct vc_data *vc, unsigned int rows,
> -		    unsigned int cols, int do_clear);
> +		    unsigned int cols, int do_clear)

Uhm... this doesn't compile.

I'm going to bounce this patch, not because I can't just add the
semicolon back and recompile it, but because that means you never
compiled it and therefore never tested it.

Please fix, test, and resubmit.

	-hpa
