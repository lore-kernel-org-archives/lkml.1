Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZFSBQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZFSBQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 21:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZFSBQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 21:16:05 -0400
Received: from mail-yx0-f177.google.com ([209.85.210.177]:64472 "EHLO
	mail-yx0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbZFSBQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 21:16:04 -0400
X-Greylist: delayed 29246 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2009 21:16:04 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iBAubW1roAqVXcdWEUvujdEyxmlbMj0Z6/m9oefDBZXr/ouf/9t0eWH4Kw8mRvEZqN
         fdIy8WjkhU3ir8yk6dyW9SrFEBxrKBq+dwY0TbTFL9+PoL/qjYp0ocbtytvGD5alhUQJ
         tEPO8sBNDuuzH5YDJ6JF+X06GF2BWwPq+kyJ8=
MIME-Version: 1.0
In-Reply-To: <b6c5339f0906181814p7f052822je8903629445c8a30@mail.gmail.com>
References: <1245366405-27426-1-git-send-email-jirislaby@gmail.com>
	 <b6c5339f0906181814p7f052822je8903629445c8a30@mail.gmail.com>
Date: Thu, 18 Jun 2009 21:16:05 -0400
Message-ID: <b6c5339f0906181816m15e2a348s3df43602278c22b8@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix beacon_int handling
From: Bob Copeland <bcopeland@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 9:14 PM, Bob Copeland<bcopeland@gmail.com> wrote:
>> Otherwise it will be set only once by upper layer through
>> bss_info_changed but not on second and further hostap executions.
>
> Shouldn't we just not destroy the value in add_interface?

Err, nevermind, that's exactly what your patch does.

-- 
Bob Copeland %% www.bobcopeland.com
