Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYIXHyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYIXHyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 03:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYIXHyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 03:54:06 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:40810 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbYIXHyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 03:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jNUV/ZFfCUzcRsN4717eQKD6xtKxTHyv8ZQCO7GCll/iYqc6uWa10zHqhMzSg3eN5/
         hps5/wRULxJ/EWoGdbv0CsPBLSDbV8l9OBkXl046QSxc5D4tjdkp3OgQ861nAwACLKYY
         dVHJzWiP4q2I879uiI6WMiHBkMCiFHAJBHNOQ=
Message-ID: <8ee0b8e80809240054r7197072exde7f75e47f56f120@mail.gmail.com>
Date: Wed, 24 Sep 2008 09:54:03 +0200
From: "Jeroen van Rijn" <jvrnix@gmail.com>
To: gshan <gshan@alcatel-lucent.com>
Subject: Re: Create real-time process from shell script
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48D99E0D.9000003@alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D99E0D.9000003@alcatel-lucent.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 3:55 AM, gshan <gshan@alcatel-lucent.com> wrote:
> Hello, Is there any way (or linux utilities) could be used to create a
> real-time process in shell script?
>
> Thanks,
> Gavin

nice -20 <command> <args>

or:

<command> <args> & pid=$!
renice -20 -p $pid

-- Jeroen
