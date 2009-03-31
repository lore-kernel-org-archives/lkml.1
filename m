Return-Path: <linux-kernel-owner+w=401wt.eu-S1763662AbZCaVrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763662AbZCaVrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763616AbZCaVqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:46:31 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:60716 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763608AbZCaVq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:46:29 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/2 V2] kaweth: Fix locking to be SMP-safe
Date: Tue, 31 Mar 2009 23:50:38 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.29-9-default; KDE/4.1.3; x86_64; ; )
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <49d264dd.YwbXLw18YaD1tQqD%Larry.Finger@lwfinger.net>
In-Reply-To: <49d264dd.YwbXLw18YaD1tQqD%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903312350.38658.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 31 März 2009 20:45:49 schrieb Larry Finger:
> On an SMP system, the following message is printed. The patch below gets
> fixes the problem.

Are you sure it is never called with disabled interrupts?

	Regards
		Oliver

