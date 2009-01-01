Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZAAQwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZAAQwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 11:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbZAAQwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 11:52:45 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:8832 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312AbZAAQwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 11:52:44 -0500
Message-ID: <f73f7ab80901010852u21ffda9sef714e8cc1730cc4@mail.gmail.com>
Date: Thu, 1 Jan 2009 11:52:41 -0500
From: "Kyle Moffett" <kyle@moffetthome.net>
To: "Sitsofe Wheeler" <sitsofe@yahoo.com>
Subject: Re: [KORG] Announcement: patchwork.kernel.org
Cc: "J. H." <warthog19@eaglescrag.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ftpadmin@kernel.org
In-Reply-To: <f73f7ab80901010842i70eabb27nf23bb66398f376d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.f9uNEYqmpJX02C68okHq8SDYyFI@ifi.uio.no>
	 <495CD285.1000501@yahoo.com>
	 <f73f7ab80901010842i70eabb27nf23bb66398f376d1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2009 at 11:42 AM, Kyle Moffett <kyle@moffetthome.net> wrote:
> On Thu, Jan 1, 2009 at 9:26 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>> J.H. wrote:
>>>
>>> If you have problems, concerns or issues please e-mail
>>> ftpadmin@kernel.org.
>>
>> I get a python error when I try and do a search:
>> http://patchwork.kernel.org/project/LKML/list/?q=lzma
>
> It looks like there is some kind of caching-related bug... I just
> tried several pages and got a python error "Site does not exist" the
> *first* time I tried to load any given page.  After it had displayed
> once as "Site does not exist", a simple reload would display the
> actual page.

Ok, appended is the copy-paste of the Django error text.

Cheers,
Kyle Moffett




Environment:

Request Method: GET
Request URL: http://patchwork.kernel.org/project/linux-acpi/list/
Django Version: 1.0-final-SVN-unknown
Python Version: 2.5.1
Installed Applications:
['django.contrib.auth',
 'django.contrib.contenttypes',
 'django.contrib.sessions',
 'django.contrib.sites',
 'django.contrib.admin',
 'patchwork',
 'registration']
Installed Middleware:
('django.middleware.common.CommonMiddleware',
 'django.contrib.sessions.middleware.SessionMiddleware',
 'django.contrib.auth.middleware.AuthenticationMiddleware',
 'django.middleware.doc.XViewMiddleware')


Traceback:
File "/usr/lib/python2.5/site-packages/django/core/handlers/base.py"
in get_response
  86.                 response = callback(request, *callback_args,
**callback_kwargs)
File "/var/www/patchwork/apps/patchwork/views/patch.py" in list
  128.             view_args = {'project_id': project.linkname})
File "/var/www/patchwork/apps/patchwork/views/__init__.py" in generic_list
  31.             list_view_params = view_args)
File "/var/www/patchwork/apps/patchwork/requestcontext.py" in __init__
  70.                 'site': Site.objects.get_current(),
File "/usr/lib/python2.5/site-packages/django/contrib/sites/models.py"
in get_current
  22.             current_site = self.get(pk=sid)
File "/usr/lib/python2.5/site-packages/django/db/models/manager.py" in get
  93.         return self.get_query_set().get(*args, **kwargs)
File "/usr/lib/python2.5/site-packages/django/db/models/query.py" in get
  303.                     % self.model._meta.object_name)

Exception Type: DoesNotExist at /project/linux-acpi/list/
Exception Value: Site matching query does not exist.
