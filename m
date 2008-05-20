Return-Path: <linux-kernel-owner+w=401wt.eu-S1764751AbYETAyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764751AbYETAyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761697AbYETAyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:54:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:21467 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYETAyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qQwFy5fWMr+ix8T+G2fMyj9zreIT5cmaqC4t2/LVhUW8r8IKI8bq+zAZCvU9GFKphLbBnur5+5Wk9lcFIN+Zmi3fMPDv0QS6Ac1yXWKE6Uv5g4ykyCDSTV0MA+3j2GBGvlnjA2bQybhjbqipl74GxMGXlftrTckhWcynkdv1sVY=
Subject: Re: significance of using 2kb long byte_rev_table in lib/bitrev.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
Cc: linux-kernel@vger.kernel.org, akinobu.mita@gmail.com
In-Reply-To: <Pine.LNX.4.64.0805191850410.18461@visualserver.org>
References: <Pine.LNX.4.64.0805191850410.18461@visualserver.org>
Content-Type: text/plain
Date: Mon, 19 May 2008 17:53:59 -0700
Message-Id: <1211244839.5915.114.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 18:59 +0200, Soumyadip Das Mahapatra wrote:
> Hi,
>  	i cant understand the significance of using 2kb size of
> bit_rev_table array in lib/bitrev.c

It's used in reversing the bits in a byte value as well, which your
patch breaks (see the bitrev8 users)

Harvey


