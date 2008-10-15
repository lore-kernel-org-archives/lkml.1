Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbYJOHX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbYJOHX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 03:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYJOHXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 03:23:51 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:45124 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYJOHXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 03:23:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=G3IO9Cu3UZoGWijtR3elSiXfhK0j+uuvXBbRjJ/4v9+B8gjinl4y4+vY8Z0yCkXPed
         Nqfb8Fbv6Q1yx3j0ey7Oq1CKty/dTnO6haXq81/tZ14DkVGjbxAeBKE/iQMwhr9ie1x/
         Fzxx7dNCd8jCTAotmWgOCyE01P3bO8ye2TLkM=
Message-ID: <df9815e70810150023w2a14fad5ge08ea4edad4ae0b1@mail.gmail.com>
Date: Wed, 15 Oct 2008 15:23:49 +0800
From: "Jike Song" <albcamus@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Creating dev nodes from driver or via uevent?
In-Reply-To: <20081015063917.GA18487@true>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081015063917.GA18487@true>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 2:39 PM, Fabiano Sidler <lists@fipscode.ch> wrote:
> Hi folks!
>
> Probably a very basic question, but is it better to directly mknod from a
> module's init funtion or to use the uevent/udev mechanism? If the latter,
> are there good overviews, explanations and comprehensive code samples
> especially for using udev,
You can refer to any in-tree driver that calls class_create() and
device_create_drvdata() afterwards.  say drivers/char/raw.c

LDD3 by Greg has some descriptions on this, but since the interface
has changed..


-- 
Thanks,
Jike
