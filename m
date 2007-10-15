Return-Path: <linux-kernel-owner+w=401wt.eu-S1764343AbXJOBBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764343AbXJOBBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 21:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbXJOBAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 21:00:53 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:48244 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbXJOBAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 21:00:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XyQP1csWdts3UkCPGJL7jiSuOSc6oQ5g3kSEj3cRM8gVNTLqu/UlhtBM1TirBVdU1wu1dQPztpBmbh2+V//7qtiO703JyWlwXy7fiCKKO7WMyXjyTF9oK2Qw1JPFFnaKvb6O5d9CyL1FHuobFwR8fFosYR3yBy+mj0OEMRoc5BQ=
Message-ID: <21d7e9970710141800h6f182849iba7ea4e6f94046b6@mail.gmail.com>
Date: Mon, 15 Oct 2007 11:00:50 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "=?ISO-8859-1?Q?N=E9meth_M=E1rton?=" <nm127@freemail.hu>
Subject: Re: [PATCH]: drm: cleanup DRM_DEBUG() parameters
Cc: "David Airlie" <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org,
       "Trivial Patch Monkey" <trivial@kernel.org>
In-Reply-To: <4712068F.20005@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <4712068F.20005@freemail.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/07, Németh Márton <nm127@freemail.hu> wrote:
> From: Márton Németh <nm127@freemail.hu>
>
> As DRM_DEBUG macro already prints out the __FUNCTION__ string (see
> drivers/char/drm/drmP.h), it is not worth doing this again. At some
> other places the ending "\n" was added.
>
> Signed-off-by: Márton Németh <nm127@freemail.hu>

Hi Márton,

Could you rebase the patch against the drm-mm tree or against -mm
kernel? as it conflicts with the stuff I'm about to push to Linus..

Dave.
